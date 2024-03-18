import { ApiProperty } from "@nestjs/swagger";
import {
  Column,
  Entity,
  JoinColumn,
  OneToOne,
  PrimaryGeneratedColumn,
} from "typeorm";
import { ReportAnswer } from "./report_answer.enum";
import { Dream } from "./dream.entity";
@Entity()
export class Report {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty()
  @Column("text", { nullable: false })
  text: string;

  @ApiProperty()
  @Column({ type: "enum", enum: ReportAnswer, default: ReportAnswer.AVERAGE })
  emotional_content: ReportAnswer;

  @ApiProperty()
  @Column({ nullable: false })
  concious: boolean;

  @ApiProperty()
  @Column({ type: "enum", enum: ReportAnswer, default: ReportAnswer.AVERAGE })
  control: ReportAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: ReportAnswer, default: ReportAnswer.AVERAGE })
  percived_elapsed_time: ReportAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: ReportAnswer, default: ReportAnswer.AVERAGE })
  sleep_time: ReportAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: ReportAnswer, default: ReportAnswer.AVERAGE })
  sleep_quality: ReportAnswer;

  @ApiProperty()
  @Column({ nullable: false, default: new Date() })
  compiled_date: Date;

  @OneToOne(() => Dream, (dream) => dream.report)
  @JoinColumn()
  dream: Dream;
}
