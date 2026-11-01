package com.library.api;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/books")
public class BookController {
    private final BookRepository repository;
    public BookController(BookRepository repository) { this.repository = repository; }

    @GetMapping
    public List<Book> getAllBooks() { return repository.findAll(); }

    @PostMapping
    public Book addBook(@RequestBody Book book) { return repository.save(book); }
}
