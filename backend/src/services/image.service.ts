import cloudinary from '../config/cloudinary';
import { ApiError } from '../utils/apiError';
import { postImagesService } from './postImages.service';

export interface UploadedImage {
  public_id: string;
  secure_url: string;
  width: number;
  height: number;
  format: string;
  bytes: number;
}

export interface ImageUploadResult extends UploadedImage {
  post_id: number;
  id: number;
  sort_order: number;
}

class ImageService {
  /**
   * Upload a single image to Cloudinary
   * Can be used for post images or standalone (avatars, etc.)
   */
  async uploadImage(
    base64Data: string,
    folder: string = 'easy-vacation/uploads'
  ): Promise<{ url: string; public_id: string }> {
    try {
      const result = await cloudinary.uploader.upload(base64Data, {
        folder,
        resource_type: 'image',
        transformation: [
          { width: 1920, height: 1080, crop: 'limit' },
          { quality: 'auto:good' },
          { fetch_format: 'auto' },
        ],
      });

      return {
        url: result.secure_url,
        public_id: result.public_id,
      };
    } catch (error: any) {
      throw new ApiError(500, 'Failed to upload image.', error.message);
    }
  }

  /**
   * Upload a single image to Cloudinary and save metadata to database (for posts)
   */
  async uploadPostImage(
    postId: number,
    base64Data: string,
    sortOrder: number = 0
  ): Promise<ImageUploadResult> {
    try {
      // Upload to Cloudinary
      const result = await cloudinary.uploader.upload(base64Data, {
        folder: `easy-vacation/posts/${postId}`,
        resource_type: 'image',
        transformation: [
          { width: 1920, height: 1080, crop: 'limit' },
          { quality: 'auto:good' },
          { fetch_format: 'auto' },
        ],
      });

      // Save to database
      const saved = await postImagesService.create({
        post_id: postId,
        public_id: result.public_id,
        secure_url: result.secure_url,
        width: result.width,
        height: result.height,
        format: result.format,
        bytes: result.bytes,
        sort_order: sortOrder,
      });

      return {
        id: saved.id,
        post_id: saved.post_id,
        public_id: saved.public_id,
        secure_url: saved.secure_url,
        width: saved.width ?? result.width,
        height: saved.height ?? result.height,
        format: saved.format ?? result.format,
        bytes: saved.bytes ?? result.bytes,
        sort_order: saved.sort_order,
      };
    } catch (error: any) {
      throw new ApiError(500, 'Failed to upload image.', error.message);
    }
  }

  /**
   * Upload multiple images for a post
   */
  async uploadImages(
    postId: number,
    images: string[]
  ): Promise<ImageUploadResult[]> {
    const results: ImageUploadResult[] = [];

    for (let i = 0; i < images.length; i++) {
      const result = await this.uploadPostImage(postId, images[i], i);
      results.push(result);
    }

    return results;
  }

  /**
   * Delete image from Cloudinary and database
   */
  async deleteImage(imageId: number): Promise<void> {
    const image = await postImagesService.getById(imageId);

    try {
      await cloudinary.uploader.destroy(image.public_id);
    } catch (error: any) {
      console.error('Cloudinary delete error:', error.message);
    }

    await postImagesService.remove(imageId);
  }

  /**
   * Delete all images for a post
   */
  async deletePostImages(postId: number): Promise<void> {
    const images = await postImagesService.list({ filters: { post_id: postId } as any });

    for (const image of images) {
      await this.deleteImage(image.id);
    }
  }

  /**
   * Update image sort order
   */
  async reorderImages(
    imageOrders: { id: number; position: number }[]
  ): Promise<void> {
    for (const order of imageOrders) {
      await postImagesService.update(order.id, { sort_order: order.position });
    }
  }

  /**
   * Get all images for a post
   */
  async getPostImages(postId: number) {
    return postImagesService.list({
      filters: { post_id: postId } as any,
      orderBy: 'sort_order',
      orderDirection: 'asc',
    });
  }

  /**
   * Get single image by ID
   */
  async getImageById(imageId: number) {
    return postImagesService.getById(imageId);
  }
}

export const imageService = new ImageService();
export default imageService;
