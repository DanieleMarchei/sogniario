import { ApiProperty } from "@nestjs/swagger";
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { User } from "./user.entity";
@Entity()
export class Psqi {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty()
  @Column()
  q1: Date;

  @ApiProperty({ type: "number" })
  @Column()
  q2: number;

  @ApiProperty()
  @Column()
  q3: Date;

  @ApiProperty({ type: "number", minimum: 0, maximum: 23 })
  @Column()
  q4_h: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 59 })
  @Column()
  q4_m: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 24 })
  @Column()
  q5_h: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 59 })
  @Column()
  q5_m: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q6: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q7: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q8: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q9: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q10: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q11: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q12: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q13: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q14: number;

  @ApiProperty()
  @Column()
  q15: boolean;

  @ApiProperty()
  @Column()
  q15_text: String;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q15_extended: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q16: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q17: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q18: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q19: number;

  @ApiProperty()
  @Column({ default: new Date() })
  compiled_date: Date;

  @ApiProperty({ type: () => User })
  @ManyToOne(() => User, (user) => user.psqis)
  user: User;
}
