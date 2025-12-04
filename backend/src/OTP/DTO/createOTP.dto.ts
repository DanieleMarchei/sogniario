import { ApiProperty } from "@nestjs/swagger";
import { Transform, TransformFnParams } from "class-transformer";
import * as sanitizeHtml from 'sanitize-html';


export class CreateOTPDto {
	@ApiProperty()
	@Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
	disallowedTagsMode: 'recursiveEscape',
	allowedTags: [],
	allowedAttributes: {}
}))
	email: string;
  
	@ApiProperty()
	@Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
	disallowedTagsMode: 'recursiveEscape',
	allowedTags: [],
	allowedAttributes: {}
}))
	confirm_email: string;

	@ApiProperty()
	@Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
	disallowedTagsMode: 'recursiveEscape',
	allowedTags: [],
	allowedAttributes: {}
}))
	password: string;


	@ApiProperty()
	@Transform((params: TransformFnParams) => sanitizeHtml(params.value , {
	disallowedTagsMode: 'recursiveEscape',
	allowedTags: [],
	allowedAttributes: {}
}))
	confirm_password: string;
  }
  