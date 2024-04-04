import { ApiProperty } from "@nestjs/swagger";
import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { User } from "./user.entity";
import { Researcher } from "./researcher.entity";

@Entity()
export class Organization {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty()
  @Column({ nullable: false })
  name: string;

  @OneToMany(() => User, (user) => user.organization)
  users: User[];

  @OneToMany(() => Researcher, (researcher) => researcher.organization)
  researchers: Researcher[];
}
