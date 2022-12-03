package com.karma.meeting.controller;

import com.karma.meeting.controller.request.RegisterRequest;
import com.karma.meeting.controller.response.Response;
import com.karma.meeting.model.util.CustomPrincipal;
import com.karma.meeting.service.UserAccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/userAccount")
public class UserAccountController {
    private final UserAccountService userAccountService;

    @PostMapping("/register")
    public Response<CustomPrincipal> register(@RequestBody RegisterRequest req){
        CustomPrincipal customPrincipal =userAccountService.register(req.getUsername(), req.getUsername(), req.getPassword(), req.getEmail(), req.getSex(), req.getDescription(), req.getBirthAt());
        return Response.success(customPrincipal);
    }

    @PostMapping("/login")
    public Response<CustomPrincipal> login(@RequestBody RegisterRequest req){
        CustomPrincipal customPrincipal =userAccountService.register(req.getUsername(), req.getUsername(), req.getPassword(), req.getEmail(), req.getSex(), req.getDescription(), req.getBirthAt());
        return Response.success(customPrincipal);
    }
}
