import { Report } from "./report.entity";
import { User } from "./user.entity";
export declare class Dream {
    id: number;
    text: string;
    created_at: Date;
    last_edit: Date;
    deleted: boolean;
    user: User;
    report: Report;
}
