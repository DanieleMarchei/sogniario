import { CrudController } from "@nestjsx/crud";
import { ReportService } from "./report.service";
import { Report } from "src/entities/report.entity";
export declare class ReportController implements CrudController<Report> {
    service: ReportService;
    constructor(service: ReportService);
}
