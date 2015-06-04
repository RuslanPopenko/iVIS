package com.imcode.services;

import com.imcode.entities.Person;

/**
 * Created by vitaly on 17.02.15.
 */
public interface PersonService extends GenericService<Person, Long> {
    Person findByPersonalId(String personalId);
}
