import { User } from "./user.entity";
export declare class Dream {
    id: number;
    text: string;
    created_at: Date;
    last_edit: Date;
    deleted: boolean;
    emotional_content: number;
    concious: boolean;
    control: number;
    percived_elapsed_time: number;
    sleep_time: number;
    sleep_quality: number;
    compiled_date: Date;
    user: User;
}
