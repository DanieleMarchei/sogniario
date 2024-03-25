import { Gender } from "./gender.enum";
import { Dream } from "./dream.entity";
import { Chronotype } from "./chronotype.entity";
import { Psqi } from "./psqi.entity";
export declare class User {
    id: number;
    username: string;
    password: string;
    birthdate: Date;
    gender: Gender;
    created_at: Date;
    first_access: boolean;
    last_edit: Date;
    deleted: boolean;
    dreams: Dream[];
    chronotypes: Chronotype[];
    psqis: Psqi[];
}
