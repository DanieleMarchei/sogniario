import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { Report } from "src/entities/report.entity";
export declare class ReportService extends TypeOrmCrudService<Report> {
    constructor(repo: any);
}
