import { ApiProperty } from "@nestjs/swagger";

export class ResetPasswordUserDto {
    @ApiProperty()
    username: string;
  
    @ApiProperty()
    new_password: string;
  }
  