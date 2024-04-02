import { ApiProperty, ApiTags } from "@nestjs/swagger";
import {
  Column,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
} from "typeorm";
import { Gender } from "./gender.enum";
import { Dream } from "./dream.entity";
import { Chronotype } from "./chronotype.entity";
import { Psqi } from "./psqi.entity";
import { Organization } from "./organization.entity";
@Entity()
export class User {
  @ApiProperty()
  @PrimaryGeneratedColumn()
  id: number;

  @ApiProperty()
  @Column({ nullable: false })
  username: string;

  @ApiProperty()
  @Column({ nullable: false })
  password: string;

  @ApiProperty()
  @Column({ nullable: false })
  type: string;

  @ApiProperty()
  @Column({ nullable: true })
  birthdate: Date;

  @ApiProperty()
  @Column({
    type: "enum",
    enum: Gender,
    default: Gender.NOT_SPECIFIED,
    nullable: false,
  })
  sex: Gender;

  @ApiProperty()
  @Column({ default: new Date() })
  created_at: Date;

  @ApiProperty()
  @Column({ default: false })
  first_access: boolean;

  @ApiProperty()
  @Column({ default: new Date() })
  last_edit: Date;

  @ApiProperty()
  @Column({ default: false })
  deleted: boolean;

  @OneToMany(() => Dream, (dream) => dream.user)
  dreams: Dream[];

  @OneToMany(() => Chronotype, (chronotype) => chronotype.user)
  chronotypes: Chronotype[];

  @OneToMany(() => Psqi, (psqi) => psqi.user)
  psqis: Psqi[];

  @ApiProperty({ type: () => Organization })
  @ManyToOne(() => Organization, (organization) => organization.users)
  organization: Organization;
}
