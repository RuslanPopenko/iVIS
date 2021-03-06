package com.imcode.controllers.restful;

import com.imcode.controllers.AbstractRestController;
import com.imcode.entities.AcademicYear;
import com.imcode.services.AcademicYearService;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/v1/{format}/academicyears")
public class AcademicYearRestControllerImpl extends AbstractRestController<AcademicYear, Long, AcademicYearService> {

}
