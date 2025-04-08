import { ApiProperty } from "@nestjs/swagger";
import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { User } from "./user.entity";
import { Researcher } from "./researcher.entity";
import { Transform, TransformFnParams } from "class-transformer";
import * as sanitizeHtml from 'sanitize-html';


@Entity()
export class Organization {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty()
  @Column({ nullable: false })
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
}))
  name: string;

  @OneToMany(() => User, (user) => user.organization)
  users: User[];

  @OneToMany(() => Researcher, (researcher) => researcher.organization)
  researchers: Researcher[];
}
