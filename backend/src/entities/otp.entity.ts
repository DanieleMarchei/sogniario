import { ApiProperty } from "@nestjs/swagger";
import { Column, Entity, PrimaryColumn, PrimaryGeneratedColumn } from "typeorm";
import * as sanitizeHtml from 'sanitize-html';
import { Transform, TransformFnParams } from 'class-transformer';
import { UUID } from "typeorm/driver/mongodb/bson.typings";

@Entity()
export class OTP {
  @ApiProperty()
  @PrimaryColumn()
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value, {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
  }))
  id: string;

  @ApiProperty()
  @Column({ nullable: false, unique: true })
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value, {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
  }))
  bcred: string;

  @ApiProperty()
  @Column({ nullable: false })
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value, {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
  }))
  salt: string;

  @ApiProperty()
  @Column({ nullable: false })
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value, {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
  }))
  hashed_email: string;


  @ApiProperty()
  @Column({ nullable: false })
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value, {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
  }))
  hashed_password: string;

  @ApiProperty()
  @Column({ nullable: false, type: "timestamptz" })
  expiration_date: Date;


  @ApiProperty()
  @Column({ nullable: false, default: false })
  checked: boolean;
}
