import { ApiProperty, ApiTags } from "@nestjs/swagger";
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { Organization } from "./organization.entity";
import { UserType } from "./user_type.enum";
@Entity()
export class Researcher {
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
  @Column({
    type: "enum",
    enum: UserType,
    default: UserType.RESEARCHER,
    nullable: false,
  })
  type: UserType;

  @ApiProperty()
  @Column({ default: new Date() })
  created_at: Date;

  @ApiProperty()
  @Column({ default: new Date() })
  last_edit: Date;

  @ApiProperty()
  @Column({ default: false })
  deleted: boolean;

  @ApiProperty({ type: () => Organization })
  @ManyToOne(() => Organization, (organization) => organization.researchers, {
    eager: true,
  })
  organization: Organization;
}
