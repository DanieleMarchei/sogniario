import { CrudController } from "@nestjsx/crud";
import { PsqiService } from "./psqi.service";
import { Psqi } from "src/entities/psqi.entity";
export declare class PsqiController implements CrudController<Psqi> {
    service: PsqiService;
    constructor(service: PsqiService);
}
