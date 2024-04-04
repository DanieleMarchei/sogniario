import { Controller } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { Crud, CrudController } from "@nestjsx/crud";
import { ResearcherService } from "./researcher.service";
import { Researcher } from "src/entities/researcher.entity";

@Crud({
  model: {
    type: Researcher,
  },
  query: {
    join: {
      organization: { eager: true },
    },
  },
})
@ApiTags("Researcher")
@ApiSecurity("bearer")
@Controller("researcher")
export class ResearcherController implements CrudController<Researcher> {
  constructor(public service: ResearcherService) {}
}
