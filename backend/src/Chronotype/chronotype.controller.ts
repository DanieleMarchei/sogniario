import { Controller } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";
import { Crud, CrudController } from "@nestjsx/crud";
import { ChronotypeService } from "./chronotype.service";
import { Chronotype } from "src/entities/chronotype.entity";

@Crud({
  model: {
    type: Chronotype,
  },
})
@ApiTags("Chronotype")
@Controller("chronotype")
export class ChronotypeController implements CrudController<Chronotype> {
  constructor(public service: ChronotypeService) {}
}
