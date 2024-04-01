import { ApiProperty } from "@nestjs/swagger";

export class DownloadDto {
  @ApiProperty()
  organizationId: number;
}
