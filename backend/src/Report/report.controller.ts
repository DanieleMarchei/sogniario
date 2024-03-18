import { Controller } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";
import { Crud, CrudController } from "@nestjsx/crud";
import { ReportService } from "./report.service";
import { Report } from "src/entities/report.entity";

@Crud({
  model: {
    type: Report,
  },
})
@ApiTags("Report")
@Controller("report")
export class ReportController implements CrudController<Report> {
  constructor(public service: ReportService) {}
}
