-- 1. Create a public bucket for menu images
INSERT INTO storage.buckets (id, name, public) 
VALUES ('menu_images', 'menu_images', true)
ON CONFLICT (id) DO NOTHING;

-- 2. Enable Storage RLS Policies
-- Allow public to see the images
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public Read Access' AND tablename = 'objects' AND schemaname = 'storage') THEN
        CREATE POLICY "Public Read Access" 
        ON storage.objects FOR SELECT 
        USING ( bucket_id = 'menu_images' );
    END IF;

    -- Allow authenticated users to upload images
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated Upload Access' AND tablename = 'objects' AND schemaname = 'storage') THEN
        CREATE POLICY "Authenticated Upload Access" 
        ON storage.objects FOR INSERT 
        WITH CHECK ( bucket_id = 'menu_images' AND auth.role() = 'authenticated' );
    END IF;

    -- Allow authenticated users to delete their own uploads (optional)
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Authenticated Delete Access' AND tablename = 'objects' AND schemaname = 'storage') THEN
        CREATE POLICY "Authenticated Delete Access" 
        ON storage.objects FOR DELETE 
        USING ( bucket_id = 'menu_images' AND auth.role() = 'authenticated' );
    END IF;
END
$$;
