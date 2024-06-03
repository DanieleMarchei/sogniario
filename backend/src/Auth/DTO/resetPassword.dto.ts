import { ApiProperty } from "@nestjs/swagger";

export class ResetPasswordDto {
    @ApiProperty()
    username: string;
  
    @ApiProperty()
    old_password: string;

    @ApiProperty()
    new_password: string;
  }
  