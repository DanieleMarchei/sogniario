import { ApiProperty } from "@nestjs/swagger";
import {
  Column,
  Entity,
  ManyToOne,
  OneToOne,
  PrimaryGeneratedColumn,
} from "typeorm";
import { User } from "./user.entity";
import { defaultIfEmpty } from "rxjs";
@Entity()
export class Dream {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty()
  @Column("text", { nullable: false })
  text: string;

  @ApiProperty()
  @Column({ default: new Date() })
  created_at: Date;

  @ApiProperty()
  @Column({ default: new Date() })
  last_edit: Date;

  @ApiProperty()
  @Column({ default: false })
  deleted: boolean;

  @ApiProperty({ minimum: 0, maximum: 4, default: 0 })
  @Column({ default: 0 })
  emotional_content: number;

  @ApiProperty()
  @Column({ default: false })
  concious: boolean;

  @ApiProperty({ minimum: 0, maximum: 4, default: 0 })
  @Column({ default: 0 })
  control: number;

  @ApiProperty({ minimum: 0, maximum: 4, default: 0 })
  @Column({ default: 0 })
  percived_elapsed_time: number;

  @ApiProperty({ minimum: 0, maximum: 4, default: 0 })
  @Column({ default: 0 })
  sleep_time: number;

  @ApiProperty({ minimum: 0, maximum: 4, default: 0 })
  @Column({ default: 0 })
  sleep_quality: number;

  @ApiProperty()
  @Column({ default: new Date() })
  compiled_date: Date;

  @ApiProperty({ type: () => User })
  @ManyToOne(() => User, (user) => user.dreams)
  user: User;
}
