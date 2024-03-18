import { PsqiAnswer } from "./psqi_answer.enum";
import { User } from "./user.entity";
export declare class Psqi {
    id: number;
    optimal_wake_up_hour: PsqiAnswer;
    optimal_go_to_sleep_hour: PsqiAnswer;
    reveille_needed: PsqiAnswer;
    how_awake_morning: PsqiAnswer;
    hungry_morning: PsqiAnswer;
    tired_morning: PsqiAnswer;
    optimal_go_to_sleep: PsqiAnswer;
    morning_workout: PsqiAnswer;
    night_tired_hour: PsqiAnswer;
    best_focus_moment: PsqiAnswer;
    tired_at_23: PsqiAnswer;
    go_to_sleep_late: PsqiAnswer;
    work_at_night: PsqiAnswer;
    physical_work_hour: PsqiAnswer;
    workout_at_22: PsqiAnswer;
    best_working_hour: PsqiAnswer;
    best_hours_in_day: PsqiAnswer;
    morning_or_evening_guy: PsqiAnswer;
    compiled_date: Date;
    user: User;
}
