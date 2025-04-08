import { ApiProperty, ApiTags } from "@nestjs/swagger";
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { UserType } from "./user_type.enum";
import * as sanitizeHtml from 'sanitize-html';
import { Transform, TransformFnParams } from 'class-transformer';

@Entity()
export class Admin {
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
  username: string;

  @ApiProperty()
  @Column({ nullable: false })
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
}))
  password: string;

  @ApiProperty()
  @Column({
    type: "enum",
    enum: UserType,
    default: UserType.ADMIN,
    nullable: false,
  })
  type: UserType;

  @ApiProperty()
  @Column({ type: "timestamptz", default: () => "CURRENT_TIMESTAMP" })
  created_at: Date;

  @ApiProperty()
  @Column({ type: "timestamptz", default: () => "CURRENT_TIMESTAMP" })
  last_edit: Date;

  @ApiProperty()
  @Column({ default: false })
  deleted: boolean;
}
