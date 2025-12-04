import { ApiProperty } from "@nestjs/swagger";
import { Transform, TransformFnParams } from "class-transformer";
import * as sanitizeHtml from 'sanitize-html';


export class CheckOTPDto {

	@ApiProperty()
	@Transform((params: TransformFnParams) => sanitizeHtml(params.value, {
		disallowedTagsMode: 'recursiveEscape',
		allowedTags: [],
		allowedAttributes: {}
	}))
	uuid: string;

	@ApiProperty()
	@Transform((params: TransformFnParams) => sanitizeHtml(params.value, {
		disallowedTagsMode: 'recursiveEscape',
		allowedTags: [],
		allowedAttributes: {}
	}))
	email: string;

	@ApiProperty()
	@Transform((params: TransformFnParams) => sanitizeHtml(params.value, {
		disallowedTagsMode: 'recursiveEscape',
		allowedTags: [],
		allowedAttributes: {}
	}))
	otp: string;
}
