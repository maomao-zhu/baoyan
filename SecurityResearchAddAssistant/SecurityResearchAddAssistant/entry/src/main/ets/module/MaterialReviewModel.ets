
// model/MaterialReviewModel.ets
export class MaterialReviewItem {
  id: number = 0
  type: string = ''
  name: string = ''
  studentId: string = ''
  status: ReviewStatus = ReviewStatus.PENDING
}

export enum ReviewStatus {
  PENDING = 0,
  CONFIRMED = 1,
  APPROVED = 2,
  REJECTED = 3
}