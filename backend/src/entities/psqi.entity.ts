import { ApiProperty } from "@nestjs/swagger";
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { PsqiAnswer } from "./psqi_answer.enum";
import { User } from "./user.entity";
@Entity()
export class Psqi {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  optimal_wake_up_hour: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  optimal_go_to_sleep_hour: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  reveille_needed: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  how_awake_morning: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  hungry_morning: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  tired_morning: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  optimal_go_to_sleep: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  morning_workout: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  night_tired_hour: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  best_focus_moment: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  tired_at_23: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  go_to_sleep_late: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  work_at_night: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  physical_work_hour: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  workout_at_22: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  best_working_hour: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  best_hours_in_day: PsqiAnswer;

  @ApiProperty()
  @Column({ type: "enum", enum: PsqiAnswer, default: PsqiAnswer.AVERAGE })
  morning_or_evening_guy: PsqiAnswer;

  @ApiProperty()
  @Column({ nullable: false, default: new Date() })
  compiled_date: Date;

  @ManyToOne(() => User, (user) => user.psqis)
  user: User;
}
