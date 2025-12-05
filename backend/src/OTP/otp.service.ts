import { HttpException, HttpStatus, Injectable, UseGuards } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { User } from "src/entities/user.entity";
import { Readable } from "stream";
import PostgresInterval, { IPostgresInterval } from "postgres-interval";
import { OTP } from "src/entities/otp.entity";
import { CreateOTPDto } from "./DTO/createOTP.dto";
import { OTPGuard } from "./otp.guard";
import { UUID } from "typeorm/driver/mongodb/bson.typings";
import { CheckOTPDto } from "./DTO/checkOTP.dto";
import { LessThan } from "typeorm";

@Injectable()
export class OTPService extends TypeOrmCrudService<OTP> {
	constructor(@InjectRepository(OTP) repo) {
		super(repo);
	}

	n_minutes_into_the_future(minutes) {
		return new Date(new Date().getTime() + minutes * 60000);
	}

	longDigest(data, salt): string {
		// bcrypt only uses the first 72 bytes of the input string
		// since data is potentially longer, we have to first hash it
		// and then feed this hash into bcrypt
		const bc = require("bcrypt");
		const cr = require("crypto");
		const hmac = cr.createHmac('sha256', salt);
		hmac.update(data);
		var hdata = hmac.digest("hex");
		return bc.hashSync(hdata, 13);
	}

	longCompare(data, digest, salt): boolean {
		const bc = require("bcrypt");
		const cr = require("crypto");
		const hmac = cr.createHmac('sha256', salt);
		hmac.update(data);
		var hdata = hmac.digest("hex");
		return bc.compareSync(hdata, digest);
	}


	async createOTP(otpDTO: CreateOTPDto, insert = true): Promise<[string, string]> {
		const bc = require("bcrypt");
		const cr = require("crypto");

		var otp = cr.randomInt(100000000)
		var uuid = cr.randomUUID();
		var expire_date = this.n_minutes_into_the_future(5);

		var new_otp = new OTP();
		new_otp.id = uuid;
		new_otp.expiration_date = expire_date;
		const hmac = cr.createHmac('sha512', process.env.EMAIL_SALT);
		hmac.update(otpDTO.email);
		var hemail = hmac.digest("hex");
		new_otp.hashed_email = hemail;
		new_otp.hashed_password = bc.hashSync(otpDTO.password, 10);

		var data_to_hash = new_otp.hashed_email + new_otp.hashed_password + otp + uuid + `${expire_date}`
		var salt = bc.genSaltSync(10);
		var b_cred = this.longDigest(data_to_hash, salt);
		new_otp.bcred = b_cred;
		new_otp.salt = salt;

		if(insert){
			this.repo.save(new_otp)
		}

		return [uuid, otp];
	}

	async checkOTP(checkDTO: CheckOTPDto): Promise<[boolean, string?, string?]> {
		var savedOTP = await this.repo.findOneBy({ "id": checkDTO.uuid });
		if (savedOTP === null) {
			return [false, null, null];
		}

		const bc = require("bcrypt");

		var hashed_email = savedOTP.hashed_email;
		var hashed_password = savedOTP.hashed_password;
		var otp = checkDTO.otp;
		var uuid = checkDTO.uuid;
		var exp_date = savedOTP.expiration_date;

		var data_to_hash = hashed_email + hashed_password + otp + uuid + exp_date.toString();

		var valid_hash = this.longCompare(data_to_hash, savedOTP.bcred, savedOTP.salt)
		var now = new Date();
		var valid_date = now < exp_date;
		var is_not_checked = !savedOTP.checked;

		var is_valid = valid_hash && valid_date && is_not_checked;
		await this.markOTPAsChecked(uuid);
		if (is_valid) {
			return [true, hashed_email, hashed_password];
		} else {
			// await this.deleteOTP(uuid); TODO: ADD  A CRONJOB THAT DELETES EXPIRED OTPs
			return [false, null, null];
		}

	}

	async deleteOTP(uuid: string) {
		await this.repo.delete({ "id": uuid });
	}

	async deleteInvalidOTP(){
		var now = new Date();
		var otps = await this.repo.find({
			where: [
				{ checked: true },
				{ expiration_date: LessThan(now) }
			]
		});
		otps.forEach((otp) => {this.deleteOTP(otp.id)});
	}

	async markOTPAsChecked(uuid: string) {
		await this.repo.update({ "id": uuid }, { "checked": true });
	}

}
