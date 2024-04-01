import { Controller } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { Crud, CrudController } from "@nestjsx/crud";
import { OrganizationService } from "./organization.service";
import { Organization } from "src/entities/organization.entity";
@Crud({
  model: {
    type: Organization,
  },
})
@ApiTags("Organization")
@ApiSecurity("bearer")
@Controller("Organization")
export class OrganizationController implements CrudController<Organization> {
  constructor(public service: OrganizationService) {}
}
