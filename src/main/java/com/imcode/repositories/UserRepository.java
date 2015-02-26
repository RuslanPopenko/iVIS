package com.imcode.repositories;


import com.imcode.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserRepository extends JpaRepository<User, Long> {

    @Query("select u from User u where u.login = :login")
    User findByLogin(@Param("login") String login);

    @Query("select case when count(e) > 0 then true else false end from User e where e.login = :login and e.pwd = :pwd")
    boolean checkAutorisation(@Param("login") String login, @Param("pwd") String pwd);

}

