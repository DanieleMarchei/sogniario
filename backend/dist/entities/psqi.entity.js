"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Psqi = void 0;
const swagger_1 = require("@nestjs/swagger");
const typeorm_1 = require("typeorm");
const psqi_answer_enum_1 = require("./psqi_answer.enum");
const user_entity_1 = require("./user.entity");
let Psqi = class Psqi {
};
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Psqi.prototype, "id", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "optimal_wake_up_hour", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "optimal_go_to_sleep_hour", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "reveille_needed", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "how_awake_morning", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "hungry_morning", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "tired_morning", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "optimal_go_to_sleep", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "morning_workout", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "night_tired_hour", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "best_focus_moment", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "tired_at_23", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "go_to_sleep_late", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "work_at_night", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "physical_work_hour", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "workout_at_22", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "best_working_hour", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "best_hours_in_day", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: psqi_answer_enum_1.PsqiAnswer, default: psqi_answer_enum_1.PsqiAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Psqi.prototype, "morning_or_evening_guy", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ nullable: false, default: new Date() }),
    __metadata("design:type", Date)
], Psqi.prototype, "compiled_date", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => user_entity_1.User, (user) => user.psqis),
    __metadata("design:type", user_entity_1.User)
], Psqi.prototype, "user", void 0);
Psqi = __decorate([
    (0, typeorm_1.Entity)()
], Psqi);
exports.Psqi = Psqi;
//# sourceMappingURL=psqi.entity.js.map