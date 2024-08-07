import { Controller } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { Crud, CrudController } from "@nestjsx/crud";
import { DreamService } from "./dream.service";
import { Dream } from "src/entities/dream.entity";

@Crud({
  model: {
    type: Dream,
  },
})
@ApiTags("Dream")
@ApiSecurity("bearer")
@Controller("dream")
export class DreamController implements CrudController<Dream> {
  constructor(public service: DreamService) {}
}
