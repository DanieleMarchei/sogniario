import { ApiProperty, ApiTags } from "@nestjs/swagger";
import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { Gender } from "./gender.enum";
import { Dream } from "./dream.entity";
import { Psqi } from "./psqi.entity";
@Entity()
export class User {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty()
  @Column({ nullable: false })
  password: string;

  @ApiProperty()
  @Column({ nullable: false })
  birthdate: Date;

  @ApiProperty()
  @Column({ type: "enum", enum: Gender, default: Gender.NOT_SPECIFIED })
  gender: Gender;

  @ApiProperty()
  @Column({ nullable: false })
  created_at: Date;

  @ApiProperty()
  @Column({ nullable: false })
  first_access: boolean;

  @ApiProperty()
  @Column({ nullable: false })
  last_edit: Date;

  @ApiProperty()
  @Column({ nullable: false, default: false })
  deleted: boolean;

  @OneToMany(() => Dream, (dream) => dream.user)
  dreams: Dream[];

  @OneToMany(() => Psqi, (psqi) => psqi.user)
  psqis: Psqi[];
}
