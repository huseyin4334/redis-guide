package com.example.redis.api;

import com.example.redis.vet.Vet;
import com.example.redis.vet.VetRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collection;
import java.util.List;

@RestController
public class VetApi {

    @Autowired
    VetRepository repository;

    @GetMapping("/testapi")
    public Collection<Vet> getVets() {
        return repository.findAll();
    }
}
