import { ReportAnswer } from "./report_answer.enum";
import { Dream } from "./dream.entity";
export declare class Report {
    id: number;
    text: string;
    emotional_content: ReportAnswer;
    concious: boolean;
    control: ReportAnswer;
    percived_elapsed_time: ReportAnswer;
    sleep_time: ReportAnswer;
    sleep_quality: ReportAnswer;
    compiled_date: Date;
    dream: Dream;
}
