import { ApiProperty } from "@nestjs/swagger";
import {
  Column,
  CreateDateColumn,
  Entity,
  ManyToOne,
  PrimaryGeneratedColumn,
} from "typeorm";
import { User } from "./user.entity";
import { IPostgresInterval } from "postgres-interval";
@Entity()
export class Dream {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty()
  @Column("text", { nullable: false })
  text: string;

  @ApiProperty()
  @Column({ type: "timestamptz", default: () => "CURRENT_TIMESTAMP" })
  created_at: Date;

  @ApiProperty()
  @Column({ type: "timestamptz", default: () => "CURRENT_TIMESTAMP" })
  last_edit: Date;

  @ApiProperty()
  @Column({ default: false })
  deleted: boolean;

  @ApiProperty({ minimum: 0, maximum: 4, default: 0 })
  @Column({ default: 0 })
  emotional_content: number;

  @ApiProperty({ minimum: 0, maximum: 4, default: 0 })
  @Column({ default: 0 })
  emotional_intensity: number;

  @ApiProperty({ minimum: 0, maximum: 2, default: 0 })
  @Column({ default: 0 })
  concious: number;

  @ApiProperty({ minimum: 0, maximum: 2, default: 0 })
  @Column({ default: 0 })
  control: number;

  @ApiProperty()
  @Column({ type: 'interval' })
  percived_elapsed_time: IPostgresInterval;

  @ApiProperty({ minimum: 0, default: 0 })
  @Column({ default: 0 })
  hours_of_sleep: number;

  @ApiProperty({ minimum: 0, maximum: 4, default: 0 })
  @Column({ default: 0 })
  sleep_quality: number;

  @ApiProperty()
  @Column({ type: "timestamptz", default: () => "CURRENT_TIMESTAMP" })
  compiled_date: Date;

  @ApiProperty({ type: () => User })
  @ManyToOne(() => User, (user) => user.dreams)
  user: User;
  
}
