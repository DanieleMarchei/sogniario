import { ApiProperty } from "@nestjs/swagger";
import {
  Column,
  Entity,
  ManyToOne,
  OneToOne,
  PrimaryGeneratedColumn,
} from "typeorm";
import { Report } from "./report.entity";
import { User } from "./user.entity";
@Entity()
export class Dream {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty()
  @Column("text", { nullable: false })
  text: string;

  @ApiProperty()
  @Column({ nullable: false })
  created_at: Date;

  @ApiProperty()
  @Column({ nullable: false })
  last_edit: Date;

  @ApiProperty()
  @Column({ nullable: false, default: false })
  deleted: boolean;

  @ManyToOne(() => User, (user) => user.dreams)
  user: User;

  @OneToOne(() => Report, (report) => report.dream)
  report: Report;
}
