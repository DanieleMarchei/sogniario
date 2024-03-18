import { Controller } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";
import { Crud, CrudController } from "@nestjsx/crud";
import { PsqiService } from "./psqi.service";
import { Psqi } from "src/entities/psqi.entity";

@Crud({
  model: {
    type: Psqi,
  },
})
@ApiTags("Psqi")
@Controller("Psqi")
export class PsqiController implements CrudController<Psqi> {
  constructor(public service: PsqiService) {}
}
