import { ApiProperty } from "@nestjs/swagger";
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { User } from "./user.entity";
import { IPostgresInterval } from "postgres-interval";
import * as sanitizeHtml from 'sanitize-html';
import { Transform, TransformFnParams } from "class-transformer";

@Entity()
export class Psqi {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty({ type: 'time'})
  @Column({type: "time"})
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
}))
  q1: string;
  
  @ApiProperty({ type: "number" })
  @Column()
  q2: number;
  
  @ApiProperty({ type: 'time'})
  @Column({type: "time" })
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
}))
  q3: string;

  @ApiProperty()
  @Column({ type: 'interval' })
  q4: IPostgresInterval;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5a: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5b: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5c: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5d: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5e: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5f: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5g: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5h: number;

  @ApiProperty({ type: "number", minimum: 0, maximum: 3 })
  @Column()
  q5i: number;

  @ApiProperty({ type: "boolean" })
  @Column()
  q5j: boolean;

  @ApiProperty()
  @Column({ nullable: true })
  @Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
}))
  q5j_text: String;

  @ApiProperty({ type: "number", nullable : true })
  @Column({ nullable: true })
  q5j_frequency: number;

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

  @ApiProperty()
  @Column({ type: "timestamptz", default: () => "CURRENT_TIMESTAMP" })
  compiled_date: Date;

  @ApiProperty({ type: () => User })
  @ManyToOne(() => User, (user) => user.psqis)
  user: User;
}
