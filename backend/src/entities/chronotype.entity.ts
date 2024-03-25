import { ApiProperty } from "@nestjs/swagger";
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { User } from "./user.entity";
@Entity()
export class Chronotype {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q1: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q2: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q3: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q4: number;
  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5: number;

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
  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q15: number;

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
  @ManyToOne(() => User, (user) => user.chronotypes)
  user: User;
}
