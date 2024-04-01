import { Controller } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { Crud, CrudController } from "@nestjsx/crud";
import { PsqiService } from "./psqi.service";
import { Psqi } from "src/entities/psqi.entity";
@Crud({
  model: {
    type: Psqi,
  },
})
@ApiTags("Psqi")
@ApiSecurity("bearer")
@Controller("Psqi")
export class PsqiController implements CrudController<Psqi> {
  constructor(public service: PsqiService) {}
}
