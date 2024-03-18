import { CrudController } from "@nestjsx/crud";
import { DreamService } from "./dream.service";
import { Dream } from "src/entities/dream.entity";
export declare class DreamController implements CrudController<Dream> {
    service: DreamService;
    constructor(service: DreamService);
}
