package com.imcode.services.jpa;

import com.imcode.entities.School;
import com.imcode.repositories.SchoolRepository;
import com.imcode.services.AbstractNamedEntityService;
import com.imcode.services.AbstractService;
import com.imcode.services.SchoolService;
import org.springframework.stereotype.Service;

@Service
public class SchoolServiceRepoImpl extends AbstractNamedEntityService<School, Long, SchoolRepository> implements SchoolService {
}
