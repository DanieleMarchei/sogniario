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
exports.Report = void 0;
const swagger_1 = require("@nestjs/swagger");
const typeorm_1 = require("typeorm");
const report_answer_enum_1 = require("./report_answer.enum");
const dream_entity_1 = require("./dream.entity");
let Report = class Report {
};
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Report.prototype, "id", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)("text", { nullable: false }),
    __metadata("design:type", String)
], Report.prototype, "text", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: report_answer_enum_1.ReportAnswer, default: report_answer_enum_1.ReportAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Report.prototype, "emotional_content", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ nullable: false }),
    __metadata("design:type", Boolean)
], Report.prototype, "concious", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: report_answer_enum_1.ReportAnswer, default: report_answer_enum_1.ReportAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Report.prototype, "control", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: report_answer_enum_1.ReportAnswer, default: report_answer_enum_1.ReportAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Report.prototype, "percived_elapsed_time", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: report_answer_enum_1.ReportAnswer, default: report_answer_enum_1.ReportAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Report.prototype, "sleep_time", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ type: "enum", enum: report_answer_enum_1.ReportAnswer, default: report_answer_enum_1.ReportAnswer.AVERAGE }),
    __metadata("design:type", Number)
], Report.prototype, "sleep_quality", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ nullable: false, default: new Date() }),
    __metadata("design:type", Date)
], Report.prototype, "compiled_date", void 0);
__decorate([
    (0, typeorm_1.OneToOne)(() => dream_entity_1.Dream, (dream) => dream.report),
    (0, typeorm_1.JoinColumn)(),
    __metadata("design:type", dream_entity_1.Dream)
], Report.prototype, "dream", void 0);
Report = __decorate([
    (0, typeorm_1.Entity)()
], Report);
exports.Report = Report;
//# sourceMappingURL=report.entity.js.map