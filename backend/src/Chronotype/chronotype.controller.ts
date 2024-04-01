import { Controller } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { Crud, CrudController } from "@nestjsx/crud";
import { ChronotypeService } from "./chronotype.service";
import { Chronotype } from "src/entities/chronotype.entity";

@Crud({
  model: {
    type: Chronotype,
  },
})
@ApiTags("Chronotype")
@ApiSecurity("bearer")
@Controller("chronotype")
export class ChronotypeController implements CrudController<Chronotype> {
  constructor(public service: ChronotypeService) {}
}
