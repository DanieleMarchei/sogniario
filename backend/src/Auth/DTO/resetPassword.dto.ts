import { ApiProperty } from "@nestjs/swagger";
import { Transform, TransformFnParams } from "class-transformer";
import * as sanitizeHtml from 'sanitize-html';


export class ResetPasswordDto {
    @ApiProperty()
    @Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
}))
    username: string;
  
    @ApiProperty()
    @Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
}))
    old_password: string;

    @ApiProperty()
    @Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
    disallowedTagsMode: 'recursiveEscape',
    allowedTags: [],
    allowedAttributes: {}
}))
    new_password: string;
  }
  