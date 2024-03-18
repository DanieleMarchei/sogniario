import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { Dream } from "src/entities/dream.entity";
export declare class DreamService extends TypeOrmCrudService<Dream> {
    constructor(repo: any);
}
