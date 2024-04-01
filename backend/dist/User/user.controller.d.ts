import { StreamableFile } from "@nestjs/common";
import { CrudController } from "@nestjsx/crud";
import { User } from "src/entities/user.entity";
import { UserService } from "./user.service";
export declare class UserController implements CrudController<User> {
    service: UserService;
    constructor(service: UserService);
    downloadDreams(res: any): Promise<StreamableFile>;
}
