import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { Psqi } from "src/entities/psqi.entity";
export declare class PsqiService extends TypeOrmCrudService<Psqi> {
    constructor(repo: any);
}
