package example.org.books_system;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import javax.validation.Valid;
import java.util.List;

@RestController
@Slf4j
public class QueueController {

    @Autowired
    private QueueService queueService;

    @GetMapping("/getQueues")
    public ResponseEntity<List<Queue>> getQueues() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            List<Queue> queues = queueService.getQueues();
            return new ResponseEntity<>(queues, HttpStatus.OK);
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PutMapping("/addQueue")
    public ResponseEntity<String> addQueue(@Valid @RequestBody Queue queue) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to add a queue has been received: {}", queue.getId());

            if (queue.getId() == null || queue.getBook() == null || queue.getUser() == null || queue.getQueueStatus() == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Validation error: All the fields are required.");
            }
            queueService.addQueue(queue);
            log.info("Queue has added successfully: {}", queue);
            return ResponseEntity.status(HttpStatus.CREATED).body("Created!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @PostMapping("/updateQueue")
    public ResponseEntity<String> updateQueue(@Valid @RequestBody Queue queue) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request to update the queue has been received: {}", queue.getId());

            if (queue.getId() == null) {
                log.error("The queue requires an ID to be updated (ID)");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Queue ID is required for update");
            }

            queueService.updateQueue(queue);
            log.info("The queue has been successfully updated: {}", queue);
            return ResponseEntity.status(HttpStatus.OK).body("Updated!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }

    @DeleteMapping("/deleteQueue/{id}")
    public ResponseEntity<String> deleteQueue(@PathVariable Long id) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication!= null && authentication.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals("ROLE_USER"))) {
            log.info("A request has been received to remove the queue with id: {}", id);

            queueService.deleteQueue(id);
            log.info("Queue with id {} has successfully deleted", id);
            return ResponseEntity.status(HttpStatus.OK).body("Deleted!");
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
    }
}
